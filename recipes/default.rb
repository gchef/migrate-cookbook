node[:migrate][:resources].each do |resource|
  migrate resource.delete(:name) do
    resource.each do |attribute, value|
      instance_variable_set("@#{attribute}", value)
    end
  end
end
