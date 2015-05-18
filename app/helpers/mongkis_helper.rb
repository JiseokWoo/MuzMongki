module MongkisHelper
  def validate_name(name)
    name =~ /\A[a-z0-9\-_]{3,15}\Z/i
  end
end
