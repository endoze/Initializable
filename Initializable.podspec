Pod::Spec.new do |s|
  s.name         = "Initializable"
  s.version      = "1.1.0"
  s.summary      = "Application Initializer protocols"

  s.description  = <<-DESC
                   Initializable is a set of protocols that allow you to initialize third party
                   frameworks and other settings on app launch. It also allows your frameworks
                   to tie into `applicationDidEnterForeground`.
                   DESC

  s.homepage     = "http://endoze.github.io/Initializable"
  s.license      = {type: "MIT", file: "LICENSE"}

  s.author             = {"Chris" => "chris@wideeyelabs.com"}

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.source       = {git: "https://github.com/endoze/Initializable.git", tag: "#{s.version}"}
  s.source_files  = ["Initializable/Initializable.swift", "Initializable/Configurable.swift"]
end
