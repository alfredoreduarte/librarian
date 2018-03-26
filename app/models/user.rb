class User < ApplicationRecord
	belongs_to :project
	has_many :readings
	has_many :articles, through: :readings
	enum status: { subscribed: 0, unsubscribed: 1 }
	after_create :assign_first_articles

	def self.send_if_time
		users = User.subscribed
		for user in users
			offset = user.timezone.to_i || -6
			user_time = Time.now.in_time_zone(offset)
			logger.info("user_time time #{user_time}")
			if user_time.hour >= 9 and user_time.hour < 11
			# if user_time.hour >= 17 and user_time.hour < 20
			# if true
				# logger.info("!!!!!! send notif !!!!!!!!")
				# if user.id == 1 # only admin
					# logger.info("!!!!!! it was admin !!!!!!!!")
					user.send_daily_content
				# end
			else
				logger.info("time for user #{user.token} is less than 8 or after 8 pm")
			end
		end
	end

	def self.assign_new_random_content
		users = User.subscribed

		for user in users
			pending_count = user.readings.where(sent: false).count
			# if user.id == 1 # only admin
				if pending_count == 0 # only add new pending to users with no pendings
					a = nil
					count = 1
					ids_to_exclude = user.articles.map{|x| x.id}
					loop do
						a = Article.limit(1).where.not(id: ids_to_exclude).order("RAND()").first
						break if a.nil? or user.articles.find_by(id: a.id).nil? or count == Article.count
						count = count + 1
					end
					if !a.nil? and user.articles.find_by(id: a.id).nil?
						user.articles << a
					else
						logger.info("All Articles have been assigned to user #{user.id}")
					end
				end
			# end
		end
	end

	def send_daily_content
		if self.status.to_sym == :subscribed
			token = self.token
			reading = self.readings.where(sent: false).order(created_at: :desc).first
			if !reading.nil?
				article = reading.article
				logger.info("Will send article #{article.id}: #{article.title}")

				require 'digest/md5'
				image_name = Digest::MD5.hexdigest("filthy#{article.id}rich") 
				image_url = "https://d3u2pxre64aoed.cloudfront.net/og/square/#{image_name}.png"

				hashids = Hashids.new('letspray', 15)
				hash_id = hashids.encode(article.id)
				url = "https://www.oremos.net/leer/#{hash_id}"

				access_token = "EAAHuoKlNulQBADAZAStvz3DLAAtV6yggKZBSqE6QStZCsZBqRrLK6XKllhgiAcBpjsu5WI9Eh8bUS8ZBt7Wve9LkfMpdtbaf5lVecA345RFqTNgqiR0CA5hWL0f8Lp3aWnI9321o5EIYq3YjbFBPLgcNnOPoyvaZCp5uZCHkAM6zgZDZD"
				conn = Faraday.new(:url => "https://graph.facebook.com")
				body = {
					messaging_type: "NON_PROMOTIONAL_SUBSCRIPTION",
					recipient: {
						id: token
					},
					message: {
						attachment: {
							type: "template",
							payload: {
								template_type: "generic",
								image_aspect_ratio: "square",
								elements: [
									{
										title: article.title,
										image_url: image_url,
										subtitle: article.content["explanation"][0..100],
										default_action: {
											type: "web_url",
											url: url,
											messenger_extensions: false
										},
										buttons: [
											{
												type: "web_url",
												url: url,
												title: "LEER AHORA"
											},
											{
												type: "element_share",
												share_contents: { 
													attachment: {
														type: "template",
														payload: {
															template_type: "generic",
															image_aspect_ratio: "square",
															elements: [
																{
																	title: article.title,
																	subtitle: article.content["explanation"][0..100],
																	image_url: image_url,
																	default_action: {
																		type: "web_url",
																		url: url
																	},
																	buttons: [
																		{
																			type: "web_url",
																			url: url, 
																			title: "Ingresa para leer la reflexión"
																		}
																	]
																}
															]
														}
													}
												}
											}
										]
									}
								]
							}
						}
					}
				}
				response = conn.post do |req|
					req.url "/v2.6/me/messages?access_token=#{access_token}"
					req.headers['Content-Type'] = 'application/json'
					req.body = body.to_json
				end
				if response.status.to_i == 200
					reading = self.readings.where(article_id: article.id).first
					reading.sent = true
					reading.save
				end
			else
				logger.info("No pending readings for user #{self.id}")
			end
		end
	end

	private
		def assign_first_articles
			i = 0
			until i > 7 or i == Article.count - 1 do
				# simulating self.assign_new_random_content
				a = nil
				count = 1
				ids_to_exclude = self.articles.map{|x| x.id}
				loop do
					a = Article.limit(1).where.not(id: ids_to_exclude).order("RAND()").first
					break if a.nil? or self.articles.find_by(id: a.id).nil? or count == Article.count
					count = count + 1
				end
				if !a.nil? and self.articles.find_by(id: a.id).nil?
					self.articles << a
					self.readings.map{ |r| r.update(sent: true) }
				else
					logger.info("All Articles have been assigned to user #{self.id}")
				end
				# simulating self.assign_new_random_content
				i = i+1
			end
		end
end
