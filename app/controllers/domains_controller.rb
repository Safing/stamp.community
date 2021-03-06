class DomainsController < ApplicationController
  def show
    @domain = Domain.find_by(name: params[:name])
    authorize(@domain)
  end

  def new
    @domain = Domain.new
    authorize(@domain)
  end

  # TODO: refactor this
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def create
    @domain = Domain.new(domain_params)
    authorize(@domain)

    if @domain.valid?
      @domain = Domain.find_or_initialize_by(name: domain_params[:name])

      if @domain.new_record?
        if @domain.url_exists?
          @domain.save!
          @domain.create_activity :create, owner: current_user

          @state = 'success'
          @link = domain_path(@domain.name)
          @header = 'Succesfully created.'
        else
          @state = 'error'
          @link = domain_path(@domain.name)
          @header = 'Domain does not exist or cannot be reached'
        end
      else
        @state = 'warning'
        @link = domain_path(@domain.name)
        @header = 'Domain already exists.'
      end
    else
      @state = 'error'
      @header = 'Invalid Domain'
    end

    respond_to do |format|
      format.js
    end
  end

  def index
    @domains = Domain.all
  end

  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def domain_params
    params.require(:domain).permit(:name)
  end
end
