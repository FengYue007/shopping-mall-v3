class Order < ApplicationRecord
  include AASM
  belongs_to :user
  has_many :order_items

  before_create :create_serial

  aasm column: 'status', no_direct_assignment: true do
    state :pending, initial: true
    state :paid, :delivered, :cancelled, :refunded

    event :pay do
      transitions from: :pending, to: :paid

      after_commit do
        puts "發送簡訊!"
        # 簡訊服務
      end
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

  private
    def create_serial
      self.serial = serial_generator(id) # dont do that
    end

    def serial_generator(id)
      Time.now.strftime("%Y%m%d#{id.to_s.rjust(8, "0")}")
    end
end
