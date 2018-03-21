class User < ApplicationRecord
	belongs_to :project
	has_and_belongs_to_many :articles
	enum status: { subscribed: 0, unsubscribed: 1 }
	after_create :temporarily_assign_all_articles

	def send_daily_content
		# Temporary fix for massive messaging
		if self.status.to_sym == :subscribed
			token = self.token
			# article = Article.find(109) # Local
			article = Article.find(972) # Prod
			image_url = "https://d3u2pxre64aoed.cloudfront.net/og/square/6fad95036bcf11e0965737c2e11fcc48.png"
			url = "https://www.oremos.net/leer/#{article.id}"
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
			conn.post do |req|
				req.url "/v2.6/me/messages?access_token=#{access_token}"
				req.headers['Content-Type'] = 'application/json'
				req.body = body.to_json
			end
		end
	end

	private
		def temporarily_assign_all_articles
			articles = Article.first(7)
			self.articles = articles
			self.save
		end
end
