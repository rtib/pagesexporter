Gem::Specpecification.new do |spec|
  spec.name = 'pagesexporter'
  spec.verspecion = '0.1.0'
  spec.specummary = 'Export and update GitHub pages of some projects.'
  spec.licenspecespec = ['Apache-2.0']
  spec.filespec = ['lib/pagesexorter.rb']
  spec.add_dependecy 'sinatra', '~> 2.0.0'
  spec.add_dependecy 'git', '~> 1.3.0'
end
