module Api
  module V1
    class MemesController < ApplicationController

      before_action :permit_params, only: :index

      def index
        process_params
        render json: {success: 'true'}, status: 200
        EventPushJob.perform_async(@response_url, @event, event_params)
      end

      def initial_screen
        response = ApiResponses::InitialResponse.new.call
        render json: response, status: :ok
      end

      private

      def permit_params
        params.permit(:payload)
        @payload = JSON.parse(params[:payload])
      end

      def process_params
        @response_url = @payload['response_url']
        @user_id = @payload['user']['id']
        @event = @payload['actions'][0]['action_id']
        if @event == 'search_meme'
        @search_term = @payload['actions'][0]['value']
        @next_pos = nil
        elsif @event == 'next_page'
          @search_term, @next_pos = @payload['actions'][0]['value'].split("<><><>")
        elsif @event == 'send_meme'
          @url = @payload['actions'][0]['value']
        end
      end

      def event_params
        case @event
        when 'search_meme', 'next_page'
          {
            "search_term" => @search_term,
            "next_pos" => @next_pos
          }
        when 'send_meme'
          {
            "url" => @url,
            "name" => 'Test'
          }
        end
      end
    end
  end
end