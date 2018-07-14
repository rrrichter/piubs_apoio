class Answer < ApplicationRecord
  has_many :calls
  def self.search(query)
    where('pergunta like ?', "%#{query}%")
  end
end
