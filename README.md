JSON-X
  Andrew Fong :: andrew.fong@opower.com

# What is JSON-X?

JSON-X is a tool to send JSON and XML to arbitrary URIs. I created it mainly as a way to test API endpoints in a repeatable way. With JSON-X, if you find yourself sending the same JSON or XML information to an API endpoint, you simply put the JSON or XML information into a file for repeated use, and put information about the endpoint into the endpoints.yml file. You can then send the information as many times you want by simply using the command:

ruby json-x.rb <section>

Where the section value corresponds to the structure in the yaml file. You will need at least one value/section in the yaml file to look up, but you can layer it as deep as you want - meaning that you can structure your yaml file to whatever makes sense to you. What fun!

You can also get help by using ruby json-x.rb --help

## Why is it called JSON-X?

When the idea for this tool originally came to me, it was when I was using some sample JSON and shell commands from one of the Jabberjaw developers to test out zwave commands to a thermostat zwave gateway. I believe the test was to simulate the zwave gateway sending the Jabberjaw server command (good or bad) and make sure the Jabberjaw server didn't echo the command twice or something to that effect. Point is that for each sample JSON file, there was a corresponding shell script which contained a few sample curl commands. Why? Probably because it was annoying to have to remember what fields and values to send in the curl command and you had to type it every time you wanted to run the script.

Originally this project was named Crystal Lake for its connection to JSON (think Jason from the Friday the 13th movie series) since that was the technology it was planned to work with. However, I didn't get around to designing this tool until Demand Response came around and I needed to test the end points set up for Honeywell to hit. Honeywell uses SOAP (XML) to communicate information to us, and since the only difference in sending XML vs JSON to endpoints is the payload I decided to create this application to send both and decided to rename the project to JSON-X as a natural progression from Crystal Lake since it now dealt with XML as well (the tenth movie within the Friday the 13th series was "Jason X").


# Why not just use curl or a third party plugin such as the REST console for Chrome?

You could use curl provided you remember all the switches to set things like the headers and which url to send to and what method to use and you don't mind retyping the command every time it's not in your command history. You could use the REST console in Chrome if you don't mind copying and pasting your request message and resetting all of the checkboxes and options every time you want to send your request.

I designed this tool to be as easy to use as I could make it while still being flexible enough in the options to handle "one off" cases where the uri may not be static enough to completely be handled by a yaml file by allowing you to specify on the command line some string to append to the end of the base uri read from the yaml file. Easy!


# Tricks and Tips

* If you specify that you're sending JSON in the header and you do not specify a file in the yaml file for that endpoint nor in the command line arguments, you'll be prompted to enter your JSON directly in the program. Useful for testing very quick JSON payloads without having to save it into another file and referencing it.


# Still left to do

* I haven't tried any actual endpoints that require any user authentication in the form of username/password.
* I need to put in some error handling. Currently I expect things to work and don't raise or catch any exceptions.
