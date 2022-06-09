module ApiResponses
  class ResultResponse
    def call(params)
      @search_term = params['search_term']
      @next_pos = params['next_pos']
      tenor_response = TenorClient.instance.search(@search_term, @next_pos)
      @data = tenor_response[:data]
      response = {
        "replace_original": "true",
        "blocks": [add_divider, add_search_bar, add_divider]
      }
      if tenor_response[:success]
        @data['results'].each do |result|
          response[:blocks] << add_image_section(result)
          response[:blocks] << add_send_section(result)
          response[:blocks] << add_divider
        end
      end
      response[:blocks] << add_next_button
      response[:blocks] << add_attribution
      response.to_json
    end

    def add_search_bar
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
      }
    end

    def add_image_section(object)
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "<#{object['itemurl']}|#{object['content_description']}>"
        },
        "accessory": {
          "type": "image",
          "image_url": object['url'],
          "alt_text": "#{object['content_description']}"
        }
      }
    end

    def add_send_section(object)
      {
        "type": "actions",
        "elements": [
          {
            "type": "button",
            "text": {
              "type": "plain_text",
              "text": "Send",
              "emoji": true
            },
            "value": object['url'],
            "action_id": "send_meme"
          }
        ]
		  }
    end

    def add_divider
      {
        "type": "divider"
      }
    end

    def add_next_button
      {
        "type": "actions",
        "elements": [
          {
            "type": "button",
            "text": {
              "type": "plain_text",
              "text": "Next 3 Results",
              "emoji": true
            },
            "value": "#{@search_term}<><><>#{@data['next']}",
            "action_id": "next_page"
          }
        ]
      }
    end


    def add_attribution
      {
        "type": "context",
        "elements": [
          {
            "type": "mrkdwn",
            "text": "Powered By <https://www.tenor.com|Tenor>"
          }
        ]
      }
    end
  end
end