This is a POC to show how to use runtime container environment variables to override hard coded .env variables.

Generally the react "process" call is used at build time to call in variables that are stored in a file.  This is great at build time, but in our case we want to use the same docker build image for several environments.

So to allow environment variables to be consumed at runtime we will generate a env-config.js file that's loaded in by the index file, then rather than referencing "process" in the js code we'll reference "window".

If there is no environment variables defined the generator that produces the env-config.js will fall back to using the .env file. This means the js code will continue to use "window" and will consume the vars defined in the .env file.

There's additional comments through the code to help walk through this process.

All the credit goes to Krunoslav Banovac with his solution found here:  https://www.freecodecamp.org/news/how-to-implement-runtime-environment-variables-with-create-react-app-docker-and-nginx-7f9d42a91d70/
I just made some changes around the caching of the env-config.js and customized it for my own needs.