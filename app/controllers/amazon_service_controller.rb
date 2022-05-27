class AmazonServiceController < ApplicationController
  def create
    respond_to do |format|
      format.json { render json: Services::RequestService.call(params: deep_symbolize_keys_params) }
    end
    # case params['request']['type']
    # when 'LaunchRequest'
    #   respond_to do |format|
    #     format.json { render json: LaunchRequest.new.handle_request(params) }
    #   end
    # when 'IntentRequest'
    #   respond_to do |format|
    #     format.json { render json: IntentRequest.new.handle_request(params[:session], params[:request][:intent]) }
    #   end
    # when 'TestRequest'
    #   respond_to do |format|
    #     format.json { render json: ComputerService.new.start_vscode }
    #   end
    # end
  end

  private
  def deep_symbolize_keys_params
    params.permit(:version, :session => {}, :context => {}, :request => {}).to_h.deep_symbolize_keys
  end
end
