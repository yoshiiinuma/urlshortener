require 'uri'
require 'securerandom'

# Keeps track of a URL and its shortened version
class Url < ActiveRecord::Base
  before_validation :set_shortened, :strip_spaces

  validates :original, presence: true, uniqueness: true,
     format: { with: %r{\Ahttps?://\S+\Z}, message: 'Invalid URL' }
  validates :shortened, uniqueness: true, length: { minimum: 6, maximum: 6 }
  validate :check_format

  def self.generate_unique
    loop do
      short = SecureRandom.base64.gsub(/[\/=]/, '')[0, 6]
      next if short !~ /\A[A-Za-z0-9]{6}\Z/
      return short unless find_by(shortened: short)
    end
  end

  def self.to_uri(url)
    URI.parse(url) rescue nil
  end

  def check_format
    return if self.class.to_uri(original)
    errors.add(:original, 'Invalid Format URL')
  end

  def strip_spaces
    return unless original
    original.strip!
  end

  def set_shortened
    return unless original
    self.shortened = self.class.generate_unique unless shortened
  end
end
