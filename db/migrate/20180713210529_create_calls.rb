class CreateCalls < ActiveRecord::Migration[5.2]
  def change
    create_table :calls do |t|
      t.string :titulo
      t.string :pergunta
      t.date :data_criacao
      t.date :data_fechamento
      t.string :status
      t.string :versao
      t.string :perfil_acesso
      t.string :detalhe_funcionalidade
      t.integer :severidade
      t.string :municipio
      t.string :uf
      t.string :categoria_id
      t.string :requerente
      t.string :sei
      t.references :answer, foreign_key: true

      t.timestamps
    end
  end
end
