class Conversation < ActiveRecord::Base
  belongs_to :sender, :foreign_key => :sender_id, class_name: 'User'
  belongs_to :recipient, :foreign_key => :recipient_id, class_name: 'User'
  belongs_to :job, :foreign_key => :job_id, class_name: 'Job'

  has_many :messages, dependent: :destroy

  attr_accessible :sender_id, :recipient_id, :job_id

  validates_uniqueness_of :sender_id, :scope => :recipient_id

  scope :involving, ->(user) do
    where("conversations.sender_id =? OR conversations.recipient_id =?",
          user.id,user.id)
  end

  scope :job_involving, ->(user,job_id) do
    where("(conversations.sender_id =? OR conversations.recipient_id =?) AND conversations.job_id = ?",
          user.id,user.id,job_id)
  end

  scope :between, ->(sender_id,recipient_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND conversations.recipient_id =?) AND (conversations.job_id = '')",
          sender_id,recipient_id,recipient_id,sender_id)
  end

  scope :between_job, ->(sender_id,recipient_id,job_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND conversations.recipient_id =?) AND (conversations.job_id = ?)",
          sender_id,recipient_id,recipient_id,sender_id,job_id)
  end
end