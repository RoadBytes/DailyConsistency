class User < ActiveRecord::Base
  validates :name,      presence:   true
  validates :email,     presence:   true,
            uniqueness: true
  validates :password,  presence:   true,
            length:     { minimum: 6 },
            if:         lambda{ new_record? || !password.nil? }

  has_secure_password 

  has_many  :goals
  has_many  :notes, -> { order(:date)}

  def next_note(current_note)
    current_index = self.notes.index(current_note)
    notes[current_index + 1].nil? ? current_note : self.notes[current_index + 1]
  end

  def previous_note(current_note)
    current_index = self.notes.index(current_note)
    current_index == 0 ? current_note : self.notes[current_index - 1]
  end

  def set_notes
    notes.group_by{|note| note.date.to_date}
  end
end
