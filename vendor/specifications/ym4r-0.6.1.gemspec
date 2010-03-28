# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ym4r}
  s.version = "0.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Guilhem Vellut"]
  s.date = %q{2008-02-06}
  s.description = %q{}
  s.email = %q{guilhem.vellut@gmail.com}
  s.extra_rdoc_files = ["README"]
  s.files = ["lib/ym4r/google_maps/api_key.rb", "lib/ym4r/google_maps/geocoding.rb", "lib/ym4r/google_maps.rb", "lib/ym4r/yahoo_maps/app_id.rb", "lib/ym4r/yahoo_maps/building_block/exception.rb", "lib/ym4r/yahoo_maps/building_block/geocoding.rb", "lib/ym4r/yahoo_maps/building_block/local_search.rb", "lib/ym4r/yahoo_maps/building_block/map_image.rb", "lib/ym4r/yahoo_maps/building_block/traffic.rb", "lib/ym4r/yahoo_maps/building_block.rb", "lib/ym4r/yahoo_maps.rb", "lib/ym4r.rb", "lib/ym4r/google_maps/config/config.yml", "test/test_geocoding.rb", "test/test_gm_geocoding.rb", "test/test_local_search.rb", "test/test_map_image.rb", "test/test_traffic.rb", "README", "MIT-LICENSE", "rakefile.rb"]
  s.homepage = %q{http://ym4r.rubyforge.org}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.requirements = ["none"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Helping the use of Google Maps and Yahoo! Maps API's from Ruby and Rails}
  s.test_files = ["test/test_geocoding.rb", "test/test_gm_geocoding.rb", "test/test_local_search.rb", "test/test_map_image.rb", "test/test_traffic.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
