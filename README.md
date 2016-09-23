# Flextrace

----

[![License](https://img.shields.io/badge/license-GPLv3-green.svg)](https://github.com/rodrigosiqueira/flextrace/blob/master/LICENSE)
[![Build Status](https://travis-ci.org/rodrigosiqueira/flextrace.svg?branch=master)](https://travis-ci.org/rodrigosiqueira/flextrace)

----

# What is Flextrace?

> It is a mechanism to collect informations in a time interval. For example,
  sometimes we want to monitoring CPU consumption during specific time
  instead of have all data of the execution. A similar example can be apply
  to the situation that we want to trace the systemcalls of a system.

# Dependencies

> Flextrace supports to collect resources utilizations and systemcalls. It is
a wrapper to collectl and strace. Because of this, you have to install:

* collectl
* strace

> If you want a to help us, you have to install one additional package to
  execute unit tests:

 * shunit2

# Usage

> You can start flextrace executing the command:

```
flextrace start
```

> If you want to stop flextrace execution, just run:

```
flextrace stop
```

> Finally, if you want to collect a sample you just have to run:

```
flextrace run-module
```

# How to enable a module

