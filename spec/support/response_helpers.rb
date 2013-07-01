module ResponseHelpers

  def response_valid?(hash)
    puts hash[:body]

    if hash[:status] > 199 and hash[:status] < 300
      response.should be_success
      response.status.should == hash[:status]
    else
      response.should_not be_success
      response.status.should == hash[:status]
    end

    body = JSON.parse(hash[:body])

    if hash[:model].present?
      if hash[:model_type].blank?
        body[hash[:root]]["id"].should == hash[:model].id 
      elsif hash[:model_type] == :first_id
        body[hash[:root]].first["id"] == hash[:model].id 
      elsif hash[:model_type] == :attributes
        hash[:attributes].each do |key, value|
          # puts "key = #{key}"
          # puts "value = #{value}"
          # puts "should = #{body[hash[:root]][key.to_s]}"
          body[hash[:root]][key.to_s].should == value
        end
      elsif hash[:model_type] == :has_child
        body[hash[:root]]["id"].should == hash[:model].children.first.id
      end
    else

      if hash[:model_type] == :attributes
        hash[:attributes].each do |key, value|
          body[hash[:root]][key.to_s].should == value
        end
      end

    end

    if hash[:message].present?
      body["message"]["content"].should hash[:message]
    else
      body["message"]["content"].should be_nil
    end

    body["message"]["type"].should == hash[:type]

  end

end
