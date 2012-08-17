class SerusuFoji < Sinatra::Base
  register Sinatra::Flash

  get '/' do
    if @sf_user
      @accounts = Account.all
    end
    erb :index
  end

  post '/accounts' do
    @account = Account.new
    @account.attributes = params[:account]
    if @account.save
      redirect '/'
    else
      erb :form
    end
  end

  get '/accounts/new' do
    @account = Account.new
    erb :form
  end

  get '/accounts/:id/edit' do
    @account = Account.find params[:id]
    erb :form
  end

  delete '/accounts/:id' do
    if Account.destroy(params[:id])
      flash[:info] = 'Account deleted.'
    else
      flash[:warning] = 'Account could not be deleted.'
    end
    redirect '/'
  end

  put '/accounts/:id' do
    @account = Account.find params[:id]
    @account.attributes = params[:account]
    if @account.save
      redirect '/'
    else
      erb :form
    end
  end

  before do
    if @sf_user = SfUser.first
      SfClient.credentials = @sf_user
    end
  end

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html

    def csrf_tag
      Rack::Csrf.tag(env)
    end
    def csrf_token
      Rack::Csrf.token(env)
    end
  end
end
