# Cochista
Se trata de una función escrita en R para scrapear los anuncios del portal coches.net. En concreto los anuncios de segunda mano. No lo he probado en otras secciones pero es posible que funcione. Extrae el título del anuncio, la marca del coche, el precio, la provincia, el año de fabricación, el tipo de motor, los kilometros que tiene el coche, cuándo se subió el anuncio y la url.

Cochisto es una función que acepta dos argumentos:

ruta = La ruta donde quieres que guarde el csv con los anuncios. Por defecto se guaradará en la raiz.
paginas = El número de páginas a scrapear. En cada página hay 30 anuncios.

