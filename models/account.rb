class Account
  ATTRIBUTES = %w[phone name website]

  attr_accessor :id
  attr_accessor *ATTRIBUTES

  def self.find(id)
    new(client.find(id).first)
  end

  def self.all
    client.all.collect do |a|
      new a
    end
  end

  def initialize(attributes = {})
    self.id = attributes['Id']
    self.phone = attributes['Phone']
    self.name = attributes['Name']
    self.website = attributes['Website']
  end

  def new_record?
    ! id
  end

  def self.destroy(id)
    ! client.delete(id)
  end

  def save
    if new_record?
      Hash === self.class.client.create(attributes)
    else
      Hash === self.class.client.update(id, attributes)
    end
  end

  def attributes
    Hash[ATTRIBUTES.collect {|attr| [attr, send(attr)] }]
  end

  def attributes=(attrs)
    ATTRIBUTES.each do |attr|
      if attrs.has_key? attr
        self.send("#{attr}=", attrs[attr])
      end
    end
  end

  private
  def self.client
    SfClient.new(self)
  end
end
