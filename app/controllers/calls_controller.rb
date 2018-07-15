class CallsController < ApplicationController
  before_action :set_call, only: [:show, :edit, :update, :destroy, :show_atendimento]
  before_action :set_answers , only: [:new, :edit, :update, :create]
  around_action :catch_not_found, only: :search

  # GET /calls
  # GET /calls.json
  def index
    @calls = Call.all
  end

  # GET /calls/1
  # GET /calls/1.json
  def show
    query = params[:search]
    puts query
    if query
      @answers = Answer.search(query)
      respond_to do |format|
        format.js
      end
    else
      @answers =  Answer.where(["id = ?",1])
    end
  end

  def associate
    @answer = Answer.find(params[:answer_id])
    @call = Call.find(params[:call_id])
    @call.answer_id = @answer.id
    @call.status = 'Resolvido'
    @call.data_fechamento = Date.today
    respond_to do |format|
      if @call.save
        format.html { redirect_to "/call/show_atendimento/#{@call.id}" , notice: 'Answer was successfully associate.' }
      end
    end
  end

  def show_atendimento
    id = params[:id]
    @answer = Answer.new
    answer = Call.find(id).answer_id
    @answers = Answer.where(id: answer)
  end

  # GET /calls/search
  def search
    @call = Call.find(params[:id])
    answer = @call.answer_id
    @answers = Answer.where(id: answer)
    respond_to do |format|
      if @call.save
        format.html { redirect_to "/call/show_atendimento/#{@call.id}" }
      end
    end
  end

  # GET /calls/new
  def new
    @call = Call.new
  end

  # GET /calls/1/edit
  def edit
  end

  # POST /calls
  # POST /calls.json
  def create
    @call = Call.new(call_params)
    @call.data_criacao = Date.today
    @call.status = "Aberto"
    @call.requerente = current_user.id
    @call.answer_id = 1
    protocol = get_protocol
    @call.id = protocol
    respond_to do |format|
      if @call.save
        format.html { redirect_to "/call/show_atendimento/#{@call.id}", notice: 'Call was successfully created.' }
        format.json { render :show, status: :created, location: @call }
      else
        format.html { render :new }
        format.json { render json: @call.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calls/1
  # PATCH/PUT /calls/1.json
  def update
    respond_to do |format|
      if @call.update(call_params)
        format.html { redirect_to "/call/show_atendimento/#{@call.id}", notice: 'Call was successfully updated.' }
        format.json { render :show, status: :ok, location: @call }
      else
        format.html { render :edit }
        format.json { render json: @call.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calls/1
  # DELETE /calls/1.json
  def destroy
    @call.destroy
    respond_to do |format|
      format.html { redirect_to calls_url, notice: 'Call was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def catch_not_found
      yield
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url, :flash => { :error => "Nº de protocolo inexistente!" }
    end


    def set_call
      @call = Call.find(params[:id])
    end

    def set_answers
      @answers = Answer.all
    end

    def get_current_time
      Time.now.strftime('%H%M%S')
    end

    def get_current_date
      Date.today.strftime("%d%m%Y")
    end

    def get_protocol
      user = current_user.id
      time = get_current_time
      date = get_current_date
      protocol = "#{user}#{time}#{date}"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def call_params
      params.require(:call).permit(:titulo, :pergunta, :data_criacao, :data_fechamento, :status, :versao, :perfil_acesso, :detalhe_funcionalidade, :severidade, :municipio, :uf, :categoria_id, :requerente, :sei, :answer_id)
    end
end
