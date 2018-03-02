class APIRouter < Grape::API
  version 'v1', using: :path

  format :json
  default_format :json
  default_error_formatter :json

  mount V1::Router
end
