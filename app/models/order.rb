class Order < ApplicationRecord
  include AASM
  belongs_to :user

aasm cloumn: 'status', no_direct_assignment: true do
    state :pending, initial: true
    state :paid, :delivered, :cancelled, :refunded

    event :pay do
      transitions from: :pending, to: :paid

      after_commit do
        puts "發送簡訊!"
        # 簡訊服務
    end

    event :deliver do
      transitions from: :paid, to: :delivered
    end

    event :cancel do
      transitions from: [:pending, :paid, :delivered], to: :cancelled
    end

    event :refund do
      transitions from: [:cancelled, :paid, :delivered], to: :refunded
    end
  end

end
end
