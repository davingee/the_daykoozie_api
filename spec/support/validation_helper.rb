module ValidationHelper
  
  def validates_presence_of(column_name, value)
    subject.valid?.should be_false
    subject.errors[column_name].should_not be_empty
    subject.send(:"#{column_name}=", value)
    subject.valid?
    subject.errors[column_name].should be_empty
  end

  def validates_length_of(column_name, valid_value, invalid_value)
    subject.send(:"#{column_name}=", invalid_value)
    subject.valid?.should be_false
    subject.errors[column_name].should_not be_empty
    subject.send(:"#{column_name}=", valid_value)
    subject.valid?
    subject.errors[column_name].should be_empty
  end

  def validates_numericality_of(column_name, valid_value, invalid_value)
    subject.send(:"#{column_name}=", invalid_value)
    subject.valid?.should be_false
    subject.errors[column_name].should_not be_empty
    subject.send(:"#{column_name}=", valid_value)
    subject.valid?
    subject.errors[column_name].should be_empty
  end

  def has_the_association?(kind, name)
    association = subject.class.reflect_on_association name
    association.macro.should == kind
  end

end
