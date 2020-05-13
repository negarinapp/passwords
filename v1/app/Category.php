<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\belongsTo;

class Category extends Model
{
    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name', 'icon_id',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'pivot',
    ];

    /**
     * A category belongs to an icon.
     *
     * @return \Illuminate\Database\Eloquent\Relations\belongsTo
     */
    public function icon(): belongsTo
    {
        return $this->belongsTo(Icon::class);
    }

    /**
     * A category belongs to many safe.
     *
     * @return \Illuminate\Database\Eloquent\Relations\belongsTo
     */
    public function safes(): belongsTo
    {
        return $this->belongsToMany(Safe::class)->withTimestamps();
    }
}