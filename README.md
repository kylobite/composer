composer
========

The language-agnostic data trafficking manager.

All you need to do is give it a configuration file that looks something like this:
```bash
python:test.py[0,1]
ruby:test.rb[1,1]
```

The syntax for this file is:

<u>compiler</u>:<u>script</u>[<u>sendInput</u>,<u>sendOutput</u>]

---

The ordering of the configuration is the order you want to files to execute.

Any line passing "1" to sendInput will take the output from the previous.

Any line passing "1" to sendOutput will be sent as input to the next.

The last script ran will be returned.
