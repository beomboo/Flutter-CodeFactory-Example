package com.gitim.kotlinlib

import android.content.Context
import android.widget.Toast

object GSITM {
    fun testToastMessage(mContext: Context){
        Toast.makeText(mContext,"테스트 메시지 입니다.",Toast.LENGTH_SHORT).show()
    }
}