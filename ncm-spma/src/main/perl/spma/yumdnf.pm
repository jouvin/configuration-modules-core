use strict;
use warnings;

package NCM::Component::spma::yumdnf;

use NCM::Component::spma::yum;
push our @ISA , qw(NCM::Component::spma::yum);

use constant YUM_CONF_FILE => "/etc/dnf/dnf.conf";

use constant DNF_MODULES_DIR => "/etc/dnf/modules.d";

use constant REPOGROUP => qw(true);

use constant REPOQUERY_FORMAT => qw(--nevra);

use constant REPO_DEPS => qw(repoquery -C --requires --resolve --qf %{NAME};%{ARCH});
# in dnf, whatrequires is passed as value to repoquery command
use constant REPO_WHATREQS => qw(repoquery -C --recursive --qf %{NAME}\n%{NAME};%{ARCH} --whatrequires);

use constant REPO_INCLUDE => 0;

use constant MODULES_TREE => "/software/modules";


# Completes any pending transactions
sub _do_complete_transaction
{
    my ($self) = @_;

    # Could be implmented using e.g. dnf remove $(dnf repoquery --duplicated --latest-limit=-1 -q)
    #   not sure it does what you think it does
    $self->debug(2, "Skipping complete_transaction, no DNF equivalent implemented");
    return 1;
}


# disable unmanaged modules by removing the configuration
sub cleanup_old_dnf_modules {
    my ($self, $directory, $modules) = @_;
    # this is pretty basic. only rely on filename of the module, not checking its content (section/name)
    return $self->_cleanup_old_something($directory, Set::Scalar->new(keys %$modules), "module", [qw(module)]);
};


# configure (and by schema default enable) modules via config file
sub generate_dnf_modules {
    my ($self, $directory, $modules) = @_;

    my $changes = 0;

    foreach my $name (sort keys %$modules) {
        my $module = $modules->{$name};

        $module->{name} = $name;

        my $trd = EDG::WP4::CCM::TextRender->new("dnf_module", $module, relpath => 'spma');
        if (! defined($trd->get_text())) {
            $self->error ("Unable to generate module $name: $trd->{fail}");
            return;
        };

        my $fh = $trd->filewriter($self->_keeps_state("$directory/$name.module"),
                                  header => "# File generated by " . __PACKAGE__ . ". Do not edit",
                                  log => $self);
        $changes += $fh->close() || 0; # handle undef
    }

    return $changes;
};


# support for enabling modules, not installing them
#   that's why the schema has no support for profiles
# directory is here for unittesting
sub modularity {
    my ($self, $process_modules, $config, $directory) = @_;

    $directory = DNF_MODULES_DIR if ! defined($directory);

    if ($process_modules) {
        my $modules = $config->getTree(MODULES_TREE);
        $self->verbose("Modules defined: ", join(",", sort keys %$modules));
        $self->cleanup_old_dnf_modules($directory, $modules) or return 0;
        return 0 if ! defined $self->generate_dnf_modules($directory, $modules);
    } else {
        $self->verbose("Ignoring modules, leaving all untouched");
    }

    return 1;
};

1;
