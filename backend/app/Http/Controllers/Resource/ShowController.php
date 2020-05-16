<?php

namespace App\Http\Controllers\Resource;

use Illuminate\Http\Request;
use App\Traits\ResourceModel;
use App\Http\Controllers\Controller;

class ShowController extends Controller
{
    use ResourceModel;

    public function __invoke(Request $request)
    {
        return ResourceModel::findOrFail($request->id)->first();
    }
}
