module ApiResponses
  class InitialResponse
    def call
      {
        "blocks": [
          {
            "dispatch_action": true,
            "type": "input",
            "element": {
              "type": "plain_text_input",
              "action_id": "search_meme",
              "placeholder": {
                "type": "plain_text",
                "text": "Search Awesome Memes"
              }
            },
            "label": {
              "type": "plain_text",
              "text": "Enter Search Term"
            }
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
      }
    end
  end
end