//
//  PhotoLibraryManager.swift
//  SnapCodes
//
//  Created by Shashank  on 1/29/16.
//  Copyright © 2016 Softway Solutions. All rights reserved.
//

import UIKit
import Photos

/**
This class inserts a photo into the album specified or creates a new album if not present and adds the photo in it. 
*/

class PhotoLibraryManager
{
    /**
     This function fetches the album with the specified name from the photo gallery.Its return type is OPTIONAL
     - Parameters:
        - albumName:The name of the album to be fetched
     - Returns:A PHAssetCollection or the specified album if present else returns NIL
     */

    private class func fetchAlbumWithName(albumName:String)->PHAssetCollection?
    {
        let fetchPredicate = PHFetchOptions()
        fetchPredicate.predicate = NSPredicate(format: "title == '" + albumName + "'")
        let fetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.albumRegular, options: fetchPredicate)
        return fetchResult.firstObject
    }
    
    /**
     This function requests for authorization to use the photo gallery and adds the image in the album both of which are specified.If the album does not exist it creates a new one and adds the image in that
     - Parameters:
        - image:The image to be inserted
        - albumName:The name of the album in which the image is to be inserted
     */

    
    class func saveImageToPhone(image:UIImage,albumName:String)
    {
        PHPhotoLibrary.requestAuthorization({(status:PHAuthorizationStatus)->Void in
            switch status
            {
            case PHAuthorizationStatus.authorized:
               insertImageAfterAuthorization(image: image,albumName: albumName)
            default:
                  print("Unable To Access Photo Library")
            }
        })
    }
    
    /**
     This function fetches the specified album from the photo library if present or creates a new one
     - Parameters:
        - image:The image to be inserted
        - albumName:The name of the album in which the image is to be inserted
     */

    
    private class func insertImageAfterAuthorization(image:UIImage,albumName:String)
    {
        let album = fetchAlbumWithName(albumName: albumName)
        guard let albumToBeInserted = album else{
            print("Creating A New Album \(albumName)")
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                }, completionHandler: {(success:Bool,error:Error?)->Void in
                    guard let errorObj = error else{
                        let album = fetchAlbumWithName(albumName: albumName)
                        guard let createdAlbum = album else{
                            print("Album Not Created")
                            return
                        }
                        addImageIntoAlbum(image: image,album: createdAlbum)
                        return
                    }
                    print(errorObj.localizedDescription)
                    return
            })
            return
        }
        addImageIntoAlbum(image: image,album: albumToBeInserted)
    }
    
    /**
     This function adds an image into the album specifed
     - Parameters:
        - image:The image to be added
        - album:The album in which the image is to inserted
     */

    private class func addImageIntoAlbum(image:UIImage,album:PHAssetCollection)
    {
        PHPhotoLibrary.shared().performChanges({
            let imgCreationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            print(imgCreationRequest)
            let albumRequest = PHAssetCollectionChangeRequest(for: album)
            guard let albumSpecificationRequest = albumRequest , let placeholderObjForImg = imgCreationRequest.placeholderForCreatedAsset else{
                print("Image Could Not Be Added")
                return
            }
            let arrAlbumSpecificationRequest:NSArray = [placeholderObjForImg]
            albumSpecificationRequest.addAssets(arrAlbumSpecificationRequest)
//            albumSpecificationRequest.addAssets([placeholderObjForImg])
            }, completionHandler: {(success:Bool,error:Error?)->Void in
                guard let errorObj = error else{
                    return
                }
                print(errorObj.localizedDescription)
        })
    }
    
}



