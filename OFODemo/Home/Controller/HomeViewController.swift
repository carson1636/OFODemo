//
//  HomeViewController.swift
//  OFODemo
//
//  Created by zhu on 2018/1/10.
//  Copyright © 2018年 Carson. All rights reserved.
//

import UIKit

extension HomeViewController: UIViewControllerTransitioningDelegate, MAMapViewDelegate, AMapSearchDelegate, AMapLocationManagerDelegate, AMapNaviWalkManagerDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ConnectPresent()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ConnectDismiss()
    }
}

class HomeViewController: UIViewController {
    
    // MARK: - 属性
    /// 地图
    var mapView: MAMapView!
    /// 定位管理器
    var locationManager: AMapLocationManager!
    /// 定位坐标
    var location: CLLocation!
    /// 热点搜索
    var search: AMapSearchAPI!
    /// 附近小黄车数据源
    var bikeDataSource: [MAPointAnnotation] = []
    /// 中心大头针
    var centerPin: CenterPinAnnotation!
    /// 中心大头针视图
    var centerPinView: MAAnnotationView!
    /// 路径规划开始、结束位置
    var startPoint, endPoint: AMapNaviPoint!
    /// 路径规划管理器
    var walkManager = AMapNaviWalkManager()
    /// 点击大头针视图
    var selectedAnnotationView: MAAnnotationView!
    /// 右视图
    var rightView: UIView {
        let tempView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 44))
        tempView.addSubview(rightBtn)
        tempView.backgroundColor = UIColor.clear
        return tempView
    }
    /// 右按钮
    var rightBtn: UIButton {
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect.init(x: 40, y: 12, width: 20, height: 20)
        btn.setImage(UIImage.init(named: "bluebar_fold"), for: UIControlState.normal)
        btn.setImage(UIImage.init(named: "bluebar_unfold"), for: UIControlState.selected)
        btn.addTarget(self, action: #selector(rightBtnDidClicked(sender:)), for: UIControlEvents.touchUpInside)
        return btn
    }
    /// 左logo
    var leftImageView: UIImageView!
    /// 刷新按钮
    var refreshBtn: UIButton!
    /// 客服按钮
    var serviceBtn: UIButton!
    /// 底部视图
    var bottom: BottomView!
    /// 箭头
    var arrowBtn: UIButton!
    /// 扫描用车
    var scanBtn: UIButton!
    
    // MARK: - 方法
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        setupNavigation()
        setupMap()
        setSide()
        setupBottomView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 地图定位
    func setupMap() {
        // 地图 (kScreenHeight-260)/2   kScreenHeight/2
        mapView = MAMapView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight+260));
        view.addSubview(mapView)
        mapView.delegate = self // 设置代理
        mapView.showsUserLocation = true // 显示定位
        mapView.userTrackingMode = .follow // 跟随移动
        mapView.isRotateEnabled = false
        
        // 热点搜索
        search = AMapSearchAPI()
        search.delegate = self
        
        // 定位
        locationManager = AMapLocationManager()
        locationManager.delegate = self
        locationManager.locatingWithReGeocode = true
        locationManager.startUpdatingLocation()
        location = CLLocation()
        
        // 导航
        walkManager.delegate = self
    }
    
    /// 搜索附近小黄车
    func searchBikeNearby() {
        searchWithLocation(mapView.userLocation.coordinate)
    }
    /// 根据位置搜索
    func searchWithLocation(_ center: CLLocationCoordinate2D) {
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        request.keywords = "餐馆"            // 关键词
        request.requireExtension = true     // 拓展关键词
        request.radius = 500                // 搜索半径
        search.aMapPOIAroundSearch(request) // 开始搜索
    }
    
    /// 中心大头针落地动画
    func centerPinAnimation() {
        let endFrame = centerPinView.frame
        centerPinView.frame = endFrame.offsetBy(dx: 0, dy: -15)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
            self.centerPinView.frame = endFrame
        }, completion: nil)
    }
    
    // MARK: 地图代理 - MAMapViewDelegate
    /// 地图移动完成
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if (wasUserAction == true && centerPin.isLockedToScreen == true) {
            mapView.removeAnnotations(bikeDataSource) // 删除显示的大头针
            bikeDataSource.removeAll() // 删除上一次附近的小黄车
            searchWithLocation(centerPin.coordinate)
        }
    }
    
    /// 自定义大头针
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        // 排除定位针
        if annotation is MAUserLocation {
            return nil
        }
        
        if annotation is CenterPinAnnotation {
            let centerIdentifier = "centerIdentifier"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: centerIdentifier)
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: centerIdentifier)
            }
            annotationView?.canShowCallout = false
            annotationView?.image = #imageLiteral(resourceName: "homePage_wholeAnchor")
            annotationView?.centerOffset = CGPoint(x: 0, y: -18)
            centerPinView = annotationView
            return annotationView
        }
        
        // 自定义大头针标识
        let annotationIdentifier = "annotationIdentifier"
        var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        annotationView?.canShowCallout = true // 是否显示气泡
        annotationView?.image = #imageLiteral(resourceName: "HomePage_nearbyBike")
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView!.centerOffset = CGPoint.init(x: 0, y: -18);
        return annotationView
    }
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        selectedAnnotationView = view
        let start = centerPin.coordinate
        let end = view.annotation.coordinate
        startPoint = AMapNaviPoint.location(withLatitude: CGFloat(start.latitude), longitude: CGFloat(start.longitude))
        endPoint = AMapNaviPoint.location(withLatitude: CGFloat(end.latitude), longitude: CGFloat(end.longitude))
        walkManager.calculateWalkRoute(withStart: [startPoint], end: [endPoint])
    }
    
    // 绘制路线层
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay is MAPolyline {
            centerPin.isLockedToScreen = false
            //mapView.visibleMapRect = overlay.boundingMapRect // 让地图显示路径区域
            let renderer = MAPolylineRenderer(overlay: overlay)
            renderer?.lineWidth = 15
            renderer?.lineJoinType = kMALineJoinRound // 连接显示类型
            renderer?.strokeImage = #imageLiteral(resourceName: "HomePage_path") // 路径填充图片
            
//            renderer?.lineCapType = kMALineCapArrow // 终点显示类型
//            renderer?.lineDashType = MALineDashType.square // 虚线路径
//            renderer?.strokeColor = UIColor.blue // 路径填充颜色
            
            return renderer
        }
        
        return nil
    }
    
    // MARK: 定位代理 - AMapLocationManagerDelegate
    /// 定位回调
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
        if self.location.altitude == 0 {
            
            // 初始化中心大头针
            centerPin = CenterPinAnnotation()
            centerPin.coordinate = location.coordinate
            centerPin.lockedScreenPoint = mapView.center
            centerPin.isLockedToScreen = true
            
            // 设置地图中心在屏幕的位置
            mapView.center = CGPoint(x: kScreenWidth/2, y: (kScreenHeight-260)/2)
            mapView.centerCoordinate = location.coordinate // 设置
            
            
            
            // 设置地图显示范围
            let span = MACoordinateSpan(latitudeDelta: CLLocationDegrees(0.005), longitudeDelta: CLLocationDegrees(0.005))
            mapView.region = MACoordinateRegion(center: location.coordinate, span: span)
            
            
            // 中心大头针的显示要放在地图设置之后
            mapView.addAnnotation(centerPin)
            mapView.showAnnotations([centerPin], animated: true)
            
            searchWithLocation(location.coordinate)
        }
        self.location = location
        
        // 去掉定位精度圈
        let present = MAUserLocationRepresentation()
        present.showsAccuracyRing = false
        mapView.update(present)
    }
    
    // MARK: 搜索代理 - AMapLocationManagerDelegate
    /// 热点搜索回调
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        guard response.pois.count > 0 else {
            let alertController = UIAlertController(title: "提示", message: "附近没有小黄车", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        // 数组转换函数 数组->数组
        self.bikeDataSource = response.pois.map {
            let annotation = MAPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees($0.location.latitude), longitude: CLLocationDegrees($0.location.longitude))
            let time = $0.distance / 100 + 1
            annotation.title = "步行 \(time)分钟"
            annotation.subtitle = "距离 \($0.distance)米"
            return annotation
        }
        
        mapView.addAnnotations(self.bikeDataSource) // 将大头针加入地图
        
        // 重新加载中心大头针，让它显示在最上层
        mapView.removeAnnotations([centerPin])
        mapView.addAnnotation(centerPin)
        self.centerPinAnimation() // 显示中心大头针落地动画
    }
    
    // MARK: 导航代理 - AMapNaviWalkManagerDelegate
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        mapView.removeOverlays(mapView.overlays) // 移除路线
        // 转换成坐标
        var coordinates: [CLLocationCoordinate2D] = []
        coordinates = (walkManager.naviRoute?.routeCoordinates.map {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude))
            return coordinate
            })!
        // 加入起始和终点位置
        let start = centerPin.coordinate
        let end = selectedAnnotationView.annotation.coordinate
        coordinates.insert(start, at: 0)
        coordinates.append(end)
        // 添加路径到地图
        let polyline = MAPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        mapView.add(polyline)
    }
    
    // MARK: - 导航
    func setupNavigation() {
        // 设置半透明导航
        let color = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        let image = self.imageWithColor(color: color)
        self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        leftImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 120*0.8, height: 26*0.8))
        leftImageView.image = UIImage(named: "yellowBikeLogo")
        
        let leftView = UIView(frame: CGRect(x: 0, y: 10, width: 120, height: 26))
        leftView.backgroundColor = UIColor.clear
        leftView.addSubview(leftImageView)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightView)
    }
    /// 右按钮响应
    @objc func rightBtnDidClicked(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            var frame = sender.frame
            let center = sender.center
            frame.size = CGSize.init(width: 43, height: 43)
            sender.frame = frame
            sender.center = center
            
            UIView.animate(withDuration: 0.3) {
                self.leftImageView.frame = CGRect(x: 0, y: 0, width: 120, height: 26)
            }
        }
        else {
            var frame = sender.frame
            let center = sender.center
            frame.size = CGSize.init(width: 20, height: 20)
            sender.frame = frame
            sender.center = center
            
            UIView.animate(withDuration: 0.3) {
                self.leftImageView.frame = CGRect(x: 0, y: 0, width: 120*0.8, height: 26*0.8)
            }
        }
    }
    
    /// 通过颜色生成图片
    func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // MARK: - 侧边栏
    func setSide() {
        // 刷新
        refreshBtn = UIButton(type: UIButtonType.custom)
        refreshBtn.frame = CGRect(x: kScreenWidth-50, y: kScreenHeight-260-50, width: 40, height: 40)
        refreshBtn.backgroundColor = UIColor.white
        refreshBtn.layer.cornerRadius = 20
        refreshBtn.setImage(UIImage(named: "leftBottomRefreshImage"), for: UIControlState.normal)
        refreshBtn.addTarget(self, action: #selector(refreshBtnDidClicked(sender:)), for: UIControlEvents.touchUpInside)
        view.addSubview(refreshBtn)
        
        // 客服
        serviceBtn = UIButton(type: UIButtonType.custom)
        serviceBtn.frame = CGRect(x: kScreenWidth-50, y: kScreenHeight-260-50-50, width: 40, height: 40)
        serviceBtn.setImage(UIImage(named: "rightBottomImage"), for: UIControlState.normal)
        serviceBtn.addTarget(self, action: #selector(servicerBtnDidClicked(sender:)), for: UIControlEvents.touchUpInside)
        view.addSubview(serviceBtn)
    }
    
    /// 刷新附近小黄车响应
    @objc func refreshBtnDidClicked(sender: UIButton) {
        mapView.removeAnnotations(bikeDataSource) // 删除显示的大头针
        bikeDataSource.removeAll() // 删除上一次附近的小黄车
        
        centerPin.isLockedToScreen = true        // 中心点锁定
        mapView.removeOverlays(mapView.overlays) // 移除路线
        
        // 设置地图显示范围
        let span = MACoordinateSpan(latitudeDelta: CLLocationDegrees(0.005), longitudeDelta: CLLocationDegrees(0.005))
        mapView.region = MACoordinateRegion(center: mapView.userLocation.coordinate, span: span)
        
        searchBikeNearby()
    }
    /// 客服按钮响应
    @objc func servicerBtnDidClicked(sender: UIButton) {
        
    }
    
    // MARK: - 底部
    func setupBottomView() {
        bottom = BottomView.init(frame: CGRect.init(x: 0, y: kScreenHeight-260, width: kScreenWidth, height: 260))
        bottom.backgroundColor = UIColor.clear // 背景透明
        view.addSubview(bottom)
        
        // 滑动手势
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDidHandle(swipe:)))
        downSwipe.direction = .down
        bottom.addGestureRecognizer(downSwipe)
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDidHandle(swipe:)))
        upSwipe.direction = .up
        bottom.addGestureRecognizer(upSwipe)
        
        // 箭头
        arrowBtn = UIButton(type: UIButtonType.custom)
        arrowBtn.frame = CGRect(x: bottom.center.x-10, y: 20, width: 20, height: 20)
        arrowBtn.setImage(UIImage(named: "arrowdown"), for: UIControlState.normal)
        arrowBtn.setImage(UIImage(named: "arrowup"), for: UIControlState.selected)
        arrowBtn.addTarget(self, action: #selector(arrowBtnDidClicked(sender:)), for: UIControlEvents.touchUpInside)
        bottom.addSubview(arrowBtn)
        
        // 扫描
        scanBtn = UIButton(type: UIButtonType.custom)
        scanBtn.frame = CGRect(x: kScreenWidth/2-75, y: 50, width: 150, height: 150)
        scanBtn.setImage(UIImage(named: "start_button_bg_scan"), for: UIControlState.normal)
        scanBtn.addTarget(self, action: #selector(scanBtnDidClicked(sender:)), for: UIControlEvents.touchUpInside)
        bottom.addSubview(scanBtn)
        // 个人中心
        let userBtn = UIButton(type: UIButtonType.custom)
        userBtn.frame = CGRect(x: 15, y: bottom.bounds.size.height-55, width: 40, height: 40)
        userBtn.setImage(UIImage(named: "user_center_icon"), for: UIControlState.normal)
        userBtn.addTarget(self, action: #selector(userBtnDidClicked(sender:)), for: UIControlEvents.touchUpInside)
        bottom.addSubview(userBtn)
        
        // 消息
        let messageBtn = UIButton(type: UIButtonType.custom)
        messageBtn.frame = CGRect(x: kScreenWidth-15-40, y: bottom.bounds.size.height-55, width: 40, height: 40)
        messageBtn.setImage(UIImage(named: "gift_icon"), for: UIControlState.normal)
        messageBtn.addTarget(self, action: #selector(messageBtnDidClicked(sender:)), for: UIControlEvents.touchUpInside)
        bottom.addSubview(messageBtn)
    }
    /// 滑动响应
    @objc func swipeDidHandle(swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .down {
            UIView.animate(withDuration: 0.3, animations: {
                self.downAnimation()
                self.arrowBtn.isSelected = !self.arrowBtn.isSelected
            })
        }
        if swipe.direction == .up {
            UIView.animate(withDuration: 0.3, animations: {
                self.upAnimation()
                self.arrowBtn.isSelected = !self.arrowBtn.isSelected
            })
        }
    }
    /// 箭头响应
    @objc func arrowBtnDidClicked(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            UIView.animate(withDuration: 0.3, animations: {
                self.downAnimation()
            })
        }
        else {
            UIView.animate(withDuration: 0.3, animations: {
                self.upAnimation()
            })
        }
    }
    // 下降变化
    func downAnimation() {
        let offsetY = 190.0
        let translation = CGAffineTransform.init(translationX: 0, y: CGFloat(offsetY))
        self.bottom.transform = translation
        self.scanBtn.transform = translation
        self.refreshBtn.transform = translation
        self.serviceBtn.transform = translation
    }
    // 上升变化
    func upAnimation() {
        self.bottom.transform = .identity
        self.scanBtn.transform = .identity
        self.refreshBtn.transform = .identity
        self.serviceBtn.transform = .identity
    }
    
    /// 扫描按钮响应
    @objc func scanBtnDidClicked(sender: UIButton) {
        
    }
    /// 用户按钮响应
    @objc func userBtnDidClicked(sender: UIButton) {
        let userVC = UserViewController.shareUser
        let userNav = UINavigationController(rootViewController: userVC)
        userNav.transitioningDelegate = self
        self.present(userNav, animated: true, completion: nil)
    }
    /// 消息按钮响应
    @objc func messageBtnDidClicked(sender: UIButton) {
        
    }
}
