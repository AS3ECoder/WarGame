package framework.module.scene
{
//	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import framework.core.AnimationMarshal;
	import framework.core.AnimationTween;
	import framework.core.GameContext;
	import framework.module.asset.AssetsManager;
	import framework.module.notification.NotificationIds;
	import framework.module.scene.vo.ViewParam;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.TouchEvent;

	/**
	 * 场景基类
	 */
	public class SceneBase extends Sprite implements IScene
	{
		public static const LAYER_GUIDE:String = "LayerGuide";	//引导层
		public static const LAYER_DRAMA:String = "LayerDrama";	//drama层
		public static const LAYER_UI:String = "LayerUI";	//场景层
		public static const LAYER_DIALOG:String = "LayerDialog";//弹出层
		public static const LAYER_EFFECT:String = "LayerEffect";//特效层
		public static const LAYER_TIP:String = "LayerTip";		//tip层
		public static const LAYER_TOP:String = "LayerTop";
		public static const ANIMATION_DURATION:Number = .2;
		public static const LAYERS:Array = [
			LAYER_UI,LAYER_DRAMA,LAYER_EFFECT,LAYER_GUIDE,LAYER_DIALOG,LAYER_TIP,LAYER_TOP
		];
		private var layers:Vector.<Sprite> = null;	//层
		
		private var regDict:Dictionary = new Dictionary();
		private var insDict:Dictionary = new Dictionary();
		private var _id:String = "";
		private var _views:Vector.<ISceneView> = new Vector.<ISceneView>();
		private var screenWidth:int = 0;
		private var screenHeight:int = 0;
		public function get id():String
		{
			return _id;
		}
		public function SceneBase(value:String)
		{
			_id = value;
			//注册字典
			regDict = new Dictionary();
			//场景实例字典
			insDict = new Dictionary();
			
			layers = new Vector.<Sprite>();
			var gameLayer:Sprite = null;
//			var scale:Number = GameContext.instance.dpiScale();
			for each(var layer:String in LAYERS)
			{
				gameLayer = new Sprite();
				addChild(gameLayer);
				gameLayer.name = layer;
				layers.push(gameLayer);
			}
			
			screenWidth = GameContext.instance.screenFullWidth;
			screenHeight = GameContext.instance.screenFullHeight;
		}
		
		public function scale(ratio:Number):void
		{
//			var realHeight:int = GameContext.instance.realContentHeight;
//			var offset:int = ((GameContext.instance.screenFullHeight  - realHeight) >> 1);
//			for each(var layer:Sprite in layers)
//			{
//				layer.y = offset;
//			}
		}
		
		public function findViewById(id:String):ISceneView
		{
			if(hasInstanceView(id))
			{
				return getView(id);
			}
			return null;
		}
		
//		private var curPopView:String = "";
//		private function onPopView(params:Object = null):void
//		{
//			var arg:ViewParam = params as ViewParam;
//			if(arg && arg.view != curPopView)
//			{
//				curPopView = arg.view;
//				var ins:Boolean = hasInstanceView(arg.view);
//				var view:ISceneView = getView(arg.view);
//				if(view && !view.isViewShow)
//				{
//					view.data = arg.data;
//					if(!ins && view)
//					{
//						var res:Array = view.getResource();
//						if(res)
//						{
//							loadViewResource(view,null,null,function():void{
//								view.onShow();
////								DialogManager.instance.showDialog(view as DisplayObject,arg);
//								showDialog(view as DisplayObject,arg);
//								curPopView = "";
//							});
//						}
//						else
//						{
//							view.onShow();
////							DialogManager.instance.showDialog(view as DisplayObject,arg);
//							showDialog(view as DisplayObject,arg);
//							curPopView = "";
//						}
//					}
//					else
//					{
//						view.onShow();
////						DialogManager.instance.showDialog(view as DisplayObject,arg);
//						showDialog(view as DisplayObject,arg);
//						curPopView = "";
//					}
//					if(viewPopStack.indexOf(view) < 0)
//					{
//						viewPopStack.push(view);
//					}
//				}
//			}
//		}
		
		/**
		 * 显示视图消息响应
		 */
		private function onShowView(params:Object = null):void
		{
			showView(params as ViewParam);
		}
		
		/**
		 * 隐藏视图响应
		 */
		private function onHideView(params:Object = null):void
		{
			hideView(params as ViewParam);
		}
		
		/**
		 * 卸载场景
		 */
		override public function dispose():void
		{
			onHide();
//			for each(var id:ISceneView in insDict)
//			{
//				if(_viewStack.indexOf(id) >= 0)
//				{
//					_viewStack.splice(_viewStack.indexOf(id),1);
//				}
//				if(viewPopStack.indexOf(id) >= 0)
//				{
//					viewPopStack.splice(viewPopStack.indexOf(id),1);
//				}
//				
//				id.dispose();
//			}
			
//			var view:Sprite = null;
//			for each(view in _viewStack)
//			{
//				view.removeFromParent(true);	
//			}
//			for each(view in viewPopStack)
//			{
//				view.removeFromParent(true);	
//			}
//
//			_viewStack = null;
//			viewPopStack = null;
			insDict = null;
			regDict = null;
			//移除监听
			super.dispose();
		}
		
		/**
		 * 暂停场景
		 */
		public function onShow():void
		{
//			if(insDict)
//			{
//				var offset:Point = new Point();
//				for each(var view:ISceneView in insDict)
//				{
//					addChild(view as starling.display.Sprite);
//				}
//			}
			addViewListener(NotificationIds.MSG_VIEW_SHOWVIEW,onShowView);
			addViewListener(NotificationIds.MSG_VIEW_HIDEVIEW,onHideView);
//			addViewListener(NotificationIds.MSG_VIEW_POPVIEW,onPopView);
			
//			for each(var view:ISceneView in insDict)
//			{
//				view.onShow();
////			}
//			for each(var view:ISceneView in viewPopStack)
//			{
//				if(currentView != view)
//				{
//					view.onShow();
//				}
//			}
//			if(currentView)
//			{
//				currentView.onShow();
//			}
			
			sendViewMessage(NotificationIds.MSG_VIEW_SCENESHOWN,this._id);
		}
		
		/**
		 * 关闭场景
		 */
		public function onHide():void
		{
			removeViewListener(NotificationIds.MSG_VIEW_SHOWVIEW,onShowView);
			removeViewListener(NotificationIds.MSG_VIEW_HIDEVIEW,onHideView);
//			removeViewListener(NotificationIds.MSG_VIEW_POPVIEW,onPopView);
			
//			for each(var view:ISceneView in insDict)
//			{
//				view.onHide();
//			}
//			for each(var view:ISceneView in viewPopStack)
//			{
//				if(currentView != view)
//				{
//					view.onHide();
//				}
//			}
//			if(currentView)
//			{
//				currentView.onHide();
//			}
		}
		
		/**
		 * 注册视图
		 */
		public function registerView(id:String,view:Class):void
		{
			regDict[id] = view;
		}
		
		/**
		 * 卸载视图
		 */
		protected function unregisterView(id:String):void
		{
			if(id in regDict)
			{
				delete regDict[id];
			}
			
			if(id in insDict)
			{
				var view:ISceneView = insDict[id];
				delete insDict[id];
				if(view)
				{
					Sprite(view).dispose();
					view = null;
				}
			}
		}
		
		private var currentView:ISceneView = null;
		private var currentViewId:String = "";
		/**
		 * 显示视图，如果没有则先创建再添加
		 */
		//protected function showView(id:String,offset:Point = null,isPop:Boolean = false):void
//		protected function showViewv(id:String,args:Array,isPop:Boolean = false):void
//		{
//			var ins:Boolean = hasInstanceView(id);
//			var view:ISceneView = getView(id);
//
//			var argLen:int = args.length;
//			var data:Object = argLen > 1 ? args[1]:null;
//			var offset:Point = argLen > 2 ? args[2]:null;
//			
//			if(view != currentView)
//			{
//				view.data = data;
//				hideView(currentViewId);
//			
//				if(_viewStack.indexOf(view) >= 0)
//				{
//					_viewStack.splice(_viewStack.indexOf(view),1);
//				}
//				_viewStack.push(view);
//				currentViewId = id;
//				currentView = view;
//				
//				if(!ins)
//				{
//					var res:Array = view.getResource();
//					if(res)
//					{
//						loadViewResource(view,offset,data,function():void{
//							addView(view,offset,data);
//							view.onShow();
//						});
//					}
//					else
//					{
//						addView(view,offset,data);
//						view.onShow();
//						view.onShowEnd();
//					}
//				}
//				else
//				{
//					addView(view,offset,data);
//					view.onShow();
//					view.onShowEnd();
//				}
//			}
//		}
		
		//当前已经弹出的视图
		private var currentPopupView:ISceneView = null;
		/**
		 * 显示视图,重新实现逻辑
		 **/
		protected function showView(args:ViewParam):void
		{
			if(args.isPop)
			{
				popView(args);
			}
			else
			{
				var view:ISceneView = getView(args.view);
				if(view)
				{
					if(_views.indexOf(view) < 0)//没有显示的视图列表的视图,已经在显示列表的不要显示
					{
						view.data = args.data;//设置视图参数,如果有
						if(!view.isLoaded())
						{
							showProgress();
							view.loadResource(function(sceneview:ISceneView):void{
								addViewToScene(view,args);
							},onResourceLoadProgress);
						}
						else
						{
							//资源已经准备完成
							addViewToScene(view,args);
						}
					}
				}
				else
				{
					//视图为空不处理
				}
			}
		}
		
		private var popMaskDict:Dictionary = new Dictionary();
		//弹出
		protected function popView(args:ViewParam):void
		{
			var view:ISceneView = getView(args.view);
			if(view)
			{
				if(_views.indexOf(view) < 0)//没有显示的视图列表的视图,已经在显示列表的不要显示
				{
					view.data = args.data;//设置视图参数,如果有
					if(!view.isLoaded())
					{
						showProgress();
						view.loadResource(function(sceneview:ISceneView):void{
							addViewToScene(view,args);
						},onResourceLoadProgress);
					}
					else
					{
						//资源已经准备完成
						addViewToScene(view,args);
					}
				}
			}
			else
			{
				//视图为空不处理
			}
		}
		
		protected function hideView(args:ViewParam):void
		{
			var view:ISceneView = getView(args.view);
			if(view)
			{
				if(_views.indexOf(view) >= 0)
				{
					removeViewFromScene(view,args);
				}
			}
		}
		
		private function onResourceLoadProgress(ratio:Number):void
		{
			updateProgress(ratio);
		}
				
		protected function showProgress():void
		{
			
		}
		protected function hideProgress():void
		{
			
		}
		protected function updateProgress(ratio:Number):void
		{
			
		}
		
		protected function playShowViewAnim(view:ISceneView,complete:Function):void
		{
			var posX:int = (screenWidth - view.viewBounds.width) >> 1;
			var posY:int = (screenHeight - view.viewBounds.height) >> 1;
			
			var eff:AnimationTween = new AnimationTween(view as DisplayObject,ANIMATION_DURATION,Transitions.EASE_IN_OUT_BACK);
			
//			var eff:Tween = new Tween(currentDialogView,ANIMATION_DURATION,Transitions.EASE_IN_OUT_BACK);
			eff.scaleTo(1);
			Sprite(view).scaleX = Sprite(view).scaleY = 0;
			eff.play(function():void{
				if(null != complete)
				{
					complete(view);
				}
			});
		}
		
		protected function playHideViewAnim(view:ISceneView,viewid:String,complete:Function):void
		{
			var eff:AnimationTween = new AnimationTween(view as DisplayObject,ANIMATION_DURATION,Transitions.EASE_IN_OUT_BACK);
			eff.scaleTo(0);
			eff.play(function():void{
				if(null != complete)
				{
					complete(viewid,view);
				}
			});
		}
		
		protected function addViewToScene(view:ISceneView,args:ViewParam):void
		{
			var child:Sprite = (view as Sprite);
			if(args.offset)
			{
				child.x = args.offset.x;
				child.y = args.offset.y;
			}
			var layer:String = (args.layer ? args.layer:LAYER_UI);
			if(args.isPop)
			{
				//添加遮罩
				var mask:Quad = new Quad(GameContext.instance.screenFullWidth,GameContext.instance.screenFullHeight,0,true);
				mask.alpha = args.maskAlpha;
				addChildToLayer(layer,mask);
				popMaskDict[view] = mask;
			}
			addChildToLayer(layer,view as Sprite);
			view.onShow();
			
			if(args.anim)
			{
				playShowViewAnim(view,onShowAnimationComplete);
			}
			else
			{
				onShowAnimationComplete(view);
			}
		}
		
		private function onShowAnimationComplete(view:ISceneView):void
		{
			_views.push(view);
			view.onShowEnd();
		}
		
		protected function removeViewFromScene(view:ISceneView,args:ViewParam):void
		{
			var child:Sprite = (view as Sprite);
			view.onHide();
			if(args.anim)
			{
				playHideViewAnim(view,args.view,onHideAnimationComplete);
			}
			else
			{
				onHideAnimationComplete(args.view,view);
			}
		}
		private function onHideAnimationComplete(id:String,view:ISceneView):void
		{
			var idx:int = _views.indexOf(view);
			if(idx >= 0)
			{
				_views.splice(idx,1);
			}
			if(view in popMaskDict)
			{
				Quad(popMaskDict[view]).removeFromParent(true);
				delete popMaskDict[view];
			}
			view.onHideEnd();
			
			Sprite(view).removeFromParent(view.isAutoDispose());
			if(view.isAutoDispose())
			{
				delete this.insDict[id];
			}
		}
				
		/**
		 * 视图是否初始化
		 */
		private function hasInstanceView(id:String):Boolean
		{
			return (insDict && id in insDict);
		}
		
		private function getView(id:String):ISceneView
		{
			var view:ISceneView = null;
			if(!(id in insDict))
			{
				if(id in regDict)
				{
					var cls:Class = regDict[id];
					view = insDict[id] = new cls(id);
				}
			}
			else
			{
				view = insDict[id];
			}
			return view;
		}
		
		private function removeView(id:String):void
		{
			if(id in insDict)
			{
				delete insDict[id];
			}
		}
		
		public function findLayerById(id:String):Sprite
		{
			return getChildByName(id) as Sprite;
		}
		
		/**
		 * 添加到指定层级
		 */
		public function addChildToLayer(layerName:String,child:DisplayObject,offset:Point = null,convert:Boolean = false):void
		{
			var layer:Sprite = getChildByName(layerName) as Sprite;
			if(layer)
			{
				if(offset)
				{
					if(convert)
					{
						offset = layer.globalToLocal(offset);
					}
					child.x = offset.x;
					child.y = offset.y;
				}
				layer.addChild(child);
			}
		}
		
		public function removeChildByLayer(layerName:String,child:DisplayObject):void
		{
			var layer:Sprite = getChildByName(layerName) as Sprite;
			if(layer && layer.contains(child))
			{
				layer.removeChild(child);
			}
		}
		
		public function needDispose():Boolean
		{
			return false;
		}
		
		
		public function closeAll():void
		{
			
//			var tmp:Array = viewQueue.concat();
//			for each(var view:Sprite in tmp)
//			{
////				view.removeFromParent();
//				closeDialog(view,false);
//			}
//			tmp = null;
//			viewQueue = [];
//			currentDialogView = null;
		}
	}
}