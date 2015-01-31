/**
 * 全局函数
 * 
 * 快捷代理函数，监听框架消息
 */
package
{
	import framework.module.msg.MessageConstants;
	import framework.module.msg.MessageManager;
	
	public function addFrameworkListener(id:String,func:Function,params:Object = null):void
	{
		MessageManager.instance.addMessageListener(MessageConstants.MESSAGE_FRAMEWORK,id,func,params);
	}
}