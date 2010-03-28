require File.dirname(__FILE__) + '/spec_helper.rb'

# Time to add your specs!
# http://rspec.info/
describe GoogleGeocoder do
  it "should parse xml output with status code 200" do
    data = File.read(File.dirname(__FILE__) + "/fixtures/google_geocoding.xml")
    result = GoogleGeocoder.extract_geocoding_results(data)
    result.should have(2).results
    first_result = result.first
    first_result[:accuracy].should == 6
    first_result[:address].should match(/penick, Berlin, Germany/)
    first_result[:country_name_code].should == "DE"
    first_result[:administrative_area_name].should == "Land Berlin"
    first_result[:sub_administrative_area_name].should == "Stadt Berlin"
    first_result[:locality_name].should == "Berlin"
    first_result[:dependent_locality_name].should match(/penick/)
    first_result[:thoroughfare_name].should == "Bahnhofstrasse"
    first_result[:postal_code_number].should == "12555"
    first_result[:lat].should == 52.454677
    first_result[:lng].should == 13.576333
    first_result[:height].should == 0.0
    
    second_result = result.last
    second_result[:accuracy].should == 5
    second_result[:country_name_code].should == "US"
    second_result[:administrative_area_name].should == "State of New York"
    second_result[:sub_administrative_area_name].should == "New York City"
    second_result[:locality_name].should == "New York"
    second_result[:dependent_locality_name].should be_nil
    second_result[:thoroughfare_name].should == "5th Avenue"
    second_result[:postal_code_number].should be_nil
    second_result[:lat].should == 52.591373
    second_result[:lng].should == 13.441115
    second_result[:height].should == 0.0
  end
  
  it "should return an empty array if status is 602" do
    GoogleGeocoder.should_receive(:extract_status_code_from_document).and_return "602"
    GoogleGeocoder.should_receive(:do_query).and_return ""
    GoogleGeocoder.geocode("rgne", :key => "justakey").should be_empty
  end
  
  it "should convert camel case" do
    GoogleGeocoder.underscore("JustAnotherTest").should == "just_another_test"
  end
  
  it "should throw an error if no key supplied for geocoding" do
    lambda {
      GoogleGeocoder.geocode("Hartmannstrr. 89, Erlangen")
    }.should raise_error(GoogleGeocoder::NoGeocodingKeySupplied)
  end
  
  it "should use google geocoding key if defined in constant" do
    GoogleGeocoder::KEY = "justakey"
    query = "just a test"
    GoogleGeocoder.should_receive(:api_url_for_query_and_key_and_output).with(query, GoogleGeocoder::KEY, "xml")
    GoogleGeocoder.should_receive(:do_query)
    GoogleGeocoder.should_receive(:extract_geocoding_results)
    
    GoogleGeocoder.geocode(query)
  end
end
