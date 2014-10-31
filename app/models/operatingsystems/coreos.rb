class Coreos < Operatingsystem
  PXEFILES = {:kernel => "coreos_production_pxe.vmlinuz", :initrd => "coreos_production_pxe_image.cpio.gz"}


  def pxe_type
    "coreos"
  end

  def url_for_boot(file)
    PXEFILES[file]
  end

  def pxedir
    ""
  end

  def display_family
    "CoreOS"
  end

  def boot_files_uri(medium, architecture, host = nil)
    raise ::Foreman::Exception.new(N_("invalid medium for %s"), to_s) unless media.include?(medium)
    raise ::Foreman::Exception.new(N_("invalid architecture for %s"), to_s) unless architectures.include?(architecture)

    # CoreOS stores x86_64 arch is amd64
    arch = architecture.to_s.gsub("x86_64","amd64")
    pxe_dir = "#{arch}-usr/#{major}.#{minor}"

    PXEFILES.values.collect do |img|
      URI.parse("#{medium_vars_to_uri(medium.path, architecture.name, self)}#{pxe_dir}/#{img}").normalize
    end
  end

  # Does this OS family use release_name in its naming scheme
  def use_release_name?
    true
  end

  def self.model_name
    superclass.model_name
  end

end