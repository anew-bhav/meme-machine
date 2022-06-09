module ApiResponses
  class SendResponse
    def call(params)
      url = params['url']
      name = params['name']
      {
        "replace_original": "true",
        "blocks": [
          {
            "type": "image",
            "title": {
              "type": "plain_text",
              "text": name,
              "emoji": true
            },
            "image_url": url,
            "alt_text": name
          },
          {
            "type": "context",
            "elements": [
              {
                "type": "mrkdwn",
                "text": "Powered By <https://www.tenor.com|Tenor>"
              }
            ]
          }
        ]
      }.to_json
    end
  end
end