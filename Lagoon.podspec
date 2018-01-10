Pod::Spec.new do |spec|
    spec.name           = "Lagoon"
    spec.version        = "1.1.1"
    spec.summary        = "The beautiful way to chain your services' logic"

    spec.homepage       = "https://github.com/incetro/Lagoon.git"
    spec.license        = "MIT"
    spec.authors        = { "incetro" => "incetro@ya.ru" }
    spec.requires_arc   = true

    spec.ios.deployment_target = "8.0"
    spec.osx.deployment_target = "10.9"

    spec.source       = { git: "https://github.com/incetro/Lagoon.git", tag: "#{spec.version}"}
    spec.source_files = "Sources/Lagoon/**/*.{h,swift}"
end