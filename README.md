自定义的一个segmentControl 文字切换的时候有视觉差动画，下面的视图切换用到的是iCarousel,关于他的用法可以参考[这个地址](https://github.com/nicklockwood/iCarousel)

##下面重点说一下有关于视觉差动画的实现，有不足的地方，欢迎大家指正。先上一个效果图，
![segmentControl](https://github.com/zhangjiang1203/ZJCustomSegment/blob/master/ZJCustomSegment/visionDifferenceGif.gif "segmentControl")

视觉差动画是有多层View组合而成，分解一下其中的层次关系 如下图:
![segmentControl](https://github.com/zhangjiang1203/ZJCustomSegment/blob/master/ZJCustomSegment/firstPage.png "segmentControl")

1.最下面一层,是几个图形依次添加到self.view上
2.第二层view要与最下面一层的某一个图形保持大小和位置的一致性，然后将它也添加到self.view上。并且将自身的clipsToBounds设置为YES,他的意思是如果它的subView超过它的大小的部分不允许显示。这也是关键的地方–只显示第二层这个图形的frame部分的subView。
3.第三层上添加与最下面一层大小和位置相同的几个图形，我在每个图形上加上一个label来显示文字，然后将它添加到第二层上面，作为第二层的subView，它只会显示与二层重叠的地方。
通过动态的改变第三层与第二层的相对位置就能实现这个效果啦~

##最上面还有一层button 我没有放在这个上面 这个只是为了点击改变当前的第二层和第三层的相对位置

开始计算相对位置，开始的时候第二层的frame是(0, 0, width/count, self.frame.size.height)]; 第三层的frame是(0, 0, self.frame.size.width, self.frame.size.height)];

![segmentControl](https://github.com/zhangjiang1203/ZJCustomSegment/blob/master/ZJCustomSegment/firstPage.png "segmentControl")

　点击第二个按钮后，我们要改变两者的位置关系如下，第三层这时的frame就是(- self.viewWidth, 0, self.viewHeight, self.viewHeight); orgin.x改变了，是一个负值，通过这种改变，可以造成一种第二层view在第三层保持不动的情况下左右移动的错觉。

![segmentControl](https://github.com/zhangjiang1203/ZJCustomSegment/blob/master/ZJCustomSegment/secondPage.png "segmentControl")



具体的代码在项目中 上面有注释

