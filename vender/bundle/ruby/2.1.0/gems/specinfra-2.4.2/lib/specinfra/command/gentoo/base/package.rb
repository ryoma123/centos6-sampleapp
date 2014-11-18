class Specinfra::Command::Gentoo::Base::Package < Specinfra::Command::Linux::Base::Package
  class << self
    def check_is_installed(package, version=nil)
      "eix #{escape(package)} --installed"
    end
  end
end
