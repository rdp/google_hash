# to actually build it locally, run extconf.rb in /ext, then make

require 'jeweler' # 1.8.4 also libxml2-dev package on linux and libxslt-dev
Jeweler::Tasks.new do |gemspec|
    gemspec.name = "google_hash"
    gemspec.summary = "Ruby wrappers to the google hash library"
    gemspec.description = gemspec.summary
    gemspec.email = "rogerdpack@gmail.com"
    gemspec.homepage = "http://github.com/rdp/ruby_google_hash"
    gemspec.authors = ["rogerdpack"]
    gemspec.add_runtime_dependency 'sane', '~> 0' # real dependency as it's used for building the gem, in the extconf.rb file itself, but not actually required by the gem at runtime 
    gemspec.add_development_dependency('hitimes', '~> 0')
end

