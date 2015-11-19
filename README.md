# Five00px
500px Test Application.

**Views:** 
There are two main views in the application:

* **PhotosViewController** : This view presents the list of featured pictures read from 500px in a collection view. Two different layouts can be chosen.
* **PhotoDetailViewController** : This view presents the detail information for a selected view. 

The collection view is populated via a data source that uses an **NSFetchedResultsController** to read the photos from the core data store.

**Core Data**

The app uses core data to persist the photos received from the 500px api (just the model, not the actual image binary).
The core data stack uses two contexts. The main context, which runs in the main thread, is used in the user interface.
The background context is associated to a private queue, and is the one that actually writes data in the sqlite store.
The background context is parent of the main context, so that all the changes are propagated and saved to disk. 

A third private context is used to import data from the network, so that it does not block the main thread.
The core data stack is implemented in the **CoreDataStore** class.



**Networking** 

* **NSURLSession** is used to implement the network communication.
* **FiveHundredPxAPI** : It's the class Implements the 500px protocol (only the featured pictures endpoint)


**Services**

* **PhotosService** : This service class retrieves the featured photos for the view controllers, isolating them from the api implementation.
* **ImageDownloaderService** : This service downloads images and implements a very basic caching. It's used by the controllers to download the actual images and the profile images.
* **PhotoImportService** : This services imports a list of photos into the core data context. It uses a private context to import it.

 