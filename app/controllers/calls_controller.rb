class CallsController < ApplicationController
  before_action :set_call, only: [:show, :edit, :update, :destroy]
  before_action :set_answers , only: [:new, :edit, :update, :create]

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
    @call.answer_id = 1
    respond_to do |format|
      if @call.save
        format.html { redirect_to @call, notice: 'Call was successfully created.' }
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
        format.html { redirect_to @call, notice: 'Call was successfully updated.' }
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
    def set_call
      @call = Call.find(params[:id])
    end

    def set_answers
      @answers = Answer.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def call_params
      params.require(:call).permit(:titulo, :pergunta, :data_criacao, :data_fechamento, :status, :versao, :perfil_acesso, :detalhe_funcionalidade, :severidade, :municipio, :uf, :categoria_id, :requerente, :sei, :answer_id)
    end
end