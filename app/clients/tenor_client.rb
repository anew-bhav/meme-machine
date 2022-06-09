class TenorClient
  include Singleton

  TENOR_BASE_URL = 'https://g.tenor.com/v1/search'.freeze

  def search(query_string, next_pos=nil)
    request_url = "#{TENOR_BASE_URL}?key=#{ENV['TENOR_API_KEY']}&media_filter=minimal&q=#{query_string}&limit=3"
    if next_pos.present?
      request_url = "#{request_url}&pos=#{next_pos}"
    end
    response = RestClient::Request.execute(method: :get, url: request_url)
    case response.code.to_i
    when 200, 202
      { success: true, data: JSON.parse(response.body) }
    when 429
      { success: false, message: 'Please go slow !!!' }
    when 404
      { success: false, message: 'Bad Resource' }
    when 500...600
      { success: false, message: 'Something Went Wrong. Please try again in sometime.'}
    end
  rescue => e
      Rails.logger.error(e.message)
      { success: false, message: 'Something Went Wrong. Please try again in sometime.'}
  end
end