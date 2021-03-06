use Mojo::Base -strict;
use Mojo::Log;
use Test::More;

subtest normal => sub {
  my $log = make_logger();
  $log->$_("standard $_") for qw(debug warn);
  history_is($log, [[debug => 'standard debug'], [warn => 'standard warn']]);
};

subtest simple => sub {
  my $log = make_logger();
  $log->logf(info  => 'no format');
  $log->logf(error => 'format %s %.3f', 'cool', 42.1234567);
  history_is($log, [[info => 'no format'], [error => 'format cool 42.123']]);
};

subtest complex => sub {
  my $log = make_logger();
  $log->logf(info => 'not so deep %s', {foo => 42});
  $log->logf(warn => 'deeper %s',      {foo => {bar => 42}});
  history_is($log,
    [[info => 'not so deep {"foo":42}'], [warn => 'deeper {"foo":{"bar":42}}']]
  );
};

done_testing;

sub history_is {
  my ($log, $exp) = @_;
  my @history = map { [@$_[1, 2]] } @{$log->history};
  is_deeply \@history, $exp, 'logged';
}

sub make_logger {
  my $log = Mojo::Log->new->with_roles('+Format')->level('debug');
  $log->unsubscribe('message') unless $ENV{HARNESS_IS_VERBOSE};
  return $log;
}
