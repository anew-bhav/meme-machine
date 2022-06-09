class EventPushJob
  include Sidekiq::Worker

  def perform(response_url, event, params)
    case event
    when 'search_meme', 'next_page'
      response = ApiResponses::ResultResponse.new.call(**params)
      RestClient.post(response_url,response )
    when 'send_meme'
      response = ApiResponses::SendResponse.new.call(**params)
      RestClient.post(response_url, response)
    end
  end
end