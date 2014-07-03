# ${license-info}
# ${developer-info}
# ${author-info}
# ${build-info}

unique template components/${project.artifactId}/config;

include { 'components/${project.artifactId}/schema' };

# Package to install.
'/software/packages' = pkg_repl('ncm-${project.artifactId}', '${no-snapshot-version}-${rpm.release}', 'noarch');

# Set prefix to root of component configuration.
prefix '/software/components/${project.artifactId}';

#'version' = '${project.version}';
#'package' = 'NCM::Component';

'active' ?= true;
'dispatch' ?= true;
'dependencies/pre' = push( 'spma' );
# Do not register for changes to /system/kernel/version as it is optional
'register_change' = append('/system/kernel');

