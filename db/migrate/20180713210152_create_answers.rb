class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.date :data
      t.string :categoria
      t.string :colaborador
      t.string :pergunta
      t.string :resposta

      t.timestamps
    end
  end
end
