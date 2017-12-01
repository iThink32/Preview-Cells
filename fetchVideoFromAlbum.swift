
    
    
    
    func movieURL()
    {
        
        PHPhotoLibrary.requestAuthorization({
            (status)-> Void in
            print(status)
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType=%d",PHAssetMediaType.Video.rawValue)
            //if already saved
            let arrPHAssets = PHAsset.fetchAssetsWithOptions(fetchOptions)
//            let arrPHAssets = PHAsset.fetchAssetsInAssetCollection(PhotoLibraryManager.fetchAlbumWithName(kAlbumName)!, options: fetchOptions)
            let phAsset = arrPHAssets[0] as! PHAsset
            PHImageManager.defaultManager().requestAVAssetForVideo(phAsset, options: nil, resultHandler: { (asset:AVAsset?, audioMix:AVAudioMix?, info:[NSObject:AnyObject]?) in
                guard let avAsset = asset else{
                    return
                }
                //main thread cuz it was taking a long time to display the image, im assuming it is running on a different thread
                dispatch_async(dispatch_get_main_queue(), {
//                    self.initializeAVPlayer(avAsset)
                })
                
//                let filePath = (info!["PHImageFileSandboxExtensionTokenKey"] as! String).componentsSeparatedByString(";")
//                print(filePath.last)
                PhotoLibraryManager.saveVideoToPhone(avAsset, albumName: kAlbumName)   //print(filePath.last)
                
            })

//            for index in 0..<arrVideoURL.count{
//                print(arrVideoURL[index] is PHAsset)
//                let asset = arrVideoURL[index] as! PHAsset
//                asset.localIdentifier
//                print(asset.localIdentifier)
//            }
        })
    }
    
    

