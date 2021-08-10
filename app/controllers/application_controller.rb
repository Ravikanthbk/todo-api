class ApplicationController < ActionController::API
  include ErrorHandling

  rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ::ActiveRecord::RecordInvalid, with: :invalid_record
  rescue_from ::ActionController::ParameterMissing, with: :param_missing
  rescue_from ::Pagy::OverflowError, with: :invalid_pagination
  # rescue_from ::NoMethodError, with: :no_method_error
  # rescue_from ::AbstractController::ActionNotFound, with: :invalid_action
  # rescue_from ActionController::RoutingError, :with => :route_not_found
  # Don't resuce from Exception as it will resuce from everything as mentioned here "http://stackoverflow.com/questions/10048173/why-is-it-bad-style-to-rescue-exception-e-in-ruby" Thanks for @Thibaut Barrère for mention that
  # rescue_from ::Exception, with: :error_occurred 
  
  
  # Pagination meta data
  def paginate(collection, vars={})
      pagy, paginated = pagy(collection, vars)
      pagy = { 
        current_page: pagy.page,
        next_page:    pagy.next,
        prev_page:    pagy.prev,
        last_page:    pagy.last,
        total_pages:  pagy.pages,
        offset:  pagy.offset,
        total_count:  pagy.count 
        }.each do |meth, val|
            paginated.define_singleton_method(meth){ val }
          end
      return paginated, pagy
  end
end
