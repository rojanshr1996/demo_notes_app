class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateNoteException extends CloudStorageException {}

class CouldNotGetAllNotesException extends CloudStorageException {}

class CouldNotGetUpdateNoteException extends CloudStorageException {}

class CouldNotGetDeleteNoteException extends CloudStorageException {}

class CouldNotUploadImage extends CloudStorageException {}
