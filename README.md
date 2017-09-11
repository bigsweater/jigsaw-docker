# Dockerized Jigsaw 

[Jigsaw](http://jigsaw.tighten.co) is a Laravel-based static site generator. 

Normally, to get it running, you'd need to have Composer and Node (and other requisite tooling) installed on your system.

But now you can just run it all in a Docker container! No need to worry about outdated versions, etc., when you come back to this project later.

This image is based on the [Composer docker image](https://hub.docker.com/_/composer/). It includes a fresh install of Node from the Alpine APK repository, as Jigsaw's PHP and Gulp scripts are tightly coupled. (Also, since node-sass seems to need to be rebuilt from source every time we `npm install`, the container also includes Alpine's `build-base` meta-package. It increases the size of the image significantly, unfortunately. Hopefully it won't be necessary in the future.)

**All the docker-compose files here assume your app lives in the current working directory.** You can change that if you'd like.

---

## Getting Started

If you don't already have a Jigsaw project up and running, all you have to do is clone this repository, `cd` into the directory, and run:

```bash
docker-compose -f init.docker-compose.yml up
```

You'll see two containers run: 

1. `jigsaw init` runs in the first container, creating a new Jigsaw project
2. `npm install` runs in the second

## Developing

```bash
docker-compose up
```

Runs a `jigsaw build local` so we're sure we're working with your latest changes, and then `gulp watch`, which kicks off BrowserSync at `localhost:3000`. Your site is automatically rebuilt with each change, and dropped into the `build_local` directory.

**🔥 Hot tip:** BrowserSync sometimes refreshes before the server is actually ready to go, resulting in a very annoying `Cannot GET /` message in your browser. You can mitigate this by setting `reloadDelay` in your BrowserSync config (in the Gulpfile):

```javascript
.browserSync({
	port: port,
	server: { baseDir: 'build_' + env },
	proxy: null,
	files: [ 'build_' + env + '/**/*' ],
	reloadDelay: 100
});
```

## Deploying

When you're ready to build your assets for production, run the two services in `prod.docker-compose.yml` **separately**, so our assets build before Jigsaw copies them over.

```bash
docker-compose -f prod.docker-compose.yml up jigsaw_build_assets && \
docker-compose -f prod.docker-compose.yml up jigsaw_build_site && 
```

This builds your site in the `build_production` directory.

You can then deploy the static assets however you wish. Since it's just a directory with simple HTML, CSS, and Javascript, you can host it anywhere.
